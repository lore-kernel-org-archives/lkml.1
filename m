Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbXHUC6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbXHUC6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 22:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbXHUC63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 22:58:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:51941 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbXHUC62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 22:58:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ss7hrcFyp5HG5sfboigqBVd4KlH11bn/KT9Y/k8y0T0fa7ws+OdH7YGKKlZg49PiSnVBU3H89WBwNRC0+Wzp4QA+QEO1+qJcLUz53Ubv9pBeElWs27tcwFmhExQ7F/khsyd8w7Wmcv00AH7YXMy67hIu7MUoDIB85xAI1RnV4wY=
Message-ID: <4ae3c140708201958x3c88b317o2ba9be64177978f5@mail.gmail.com>
Date: Mon, 20 Aug 2007 22:58:26 -0400
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: How Linux /proc filesystem convert a fd to the actual pathname?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the Linux proc filesystem,  /proc/[pid]/fd is a link to the
actually the actual pathname of the opened file.

I am curious how Linux convert an fd to the pathname?  Does it
recursively walk back from current dentry to the root?

Can someone point me to the right place in the kernel where this
functionality is implemented?

Many thanks in advance!

-x
