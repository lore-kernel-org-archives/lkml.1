Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbZD1Spd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbZD1Spd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZD1SpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:45:21 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:50824 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbZD1SpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=pXabZ2by2Ll7D7q79LiCsszScAgmp15karYuh3zPSf8wezAqR3nPE5A9im5HKYNKVU
         LSlvl45sgi8tWYSRdRFB+P02JUDxTZfHZ3XCTFNOOSVaVmRJ1NzSnm+IEdJOAehwypcd
         CsP4lcD/Tq1YfQFx05fcHeze7BzFuCBVOqEbQ=
MIME-Version: 1.0
Date: Tue, 28 Apr 2009 13:45:18 -0500
Message-ID: <524f69650904281145v6c94094er7c31dacff3cec0b4@mail.gmail.com>
Subject: String conversions
From: Steve French <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In looking at various patches for more accurately sizing the required
buffer needed for conversions to UTF-8, the following question came up
more than once.

Functions which do string copying often null terminate the target
string (single byte of \0), and size strings one byte larger than
their string name (for UCS-2 this does not work since the null
termination is two bytes).   Are there local nls codepages in Linux
kernel which require double null termination (e.g. DBCS asian code
pages), and if so how do you tell which ones require "double null
termination?"

-- 
Thanks,

Steve
