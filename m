Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXJUIEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXJUIEH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 04:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbXJUIDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 04:03:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:31522 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbXJUIDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 04:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gC2OUf8d17iYVCciNJ1lQunJsZl6/GeFaaMzfJlaT5y3GoJs17Aahu/1Y/LdIfyNFk2ukgYkvCkQCDmbnsc544WPzOBJesK1cVDNeGGJXQilg9lvcXXItDAPMdxk1xzj/0CztHPNy+GpLPJS5seiK9bMAilD1V4pWLAuORv6FQY=
Message-ID: <ef242d300710210103x1a8ec38ev7b0d1e93a5739ecb@mail.gmail.com>
Date: Sun, 21 Oct 2007 16:03:47 +0800
From: "Nai XIA" <nelson.xia@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: The meaning of first_logical_block in do_mpage_readpage
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi, it may be a stupid question, but I am not quite clear about what
"first_logical_block" is used for as one of parameters of
"do_mpage_readpage".

I searched all the source code and I found that "first_logical_block"
always equals zero when passed to "do_mpage_readpage" and is  used
only in scope of "do_mpage_readpage".

This makes me wonder about:
1. when should "first_logical_block" passed as non-zero values ?
2. why "first_logical_block" is one of args of "do_mpage_readpage"
instead of being a local variable of it ? ( it seems that no one uses
"first_logical_block" outside  "do_mpage_readpage")

Anyone can help me out .
Thanks in advance!
