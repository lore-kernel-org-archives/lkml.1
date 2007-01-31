Return-Path: <linux-kernel-owner+w=401wt.eu-S933303AbXAaOe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303AbXAaOe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 09:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933304AbXAaOe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 09:34:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:10379 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933303AbXAaOe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 09:34:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QHOF2O2sZwP+Z92CA+NHxLeJC/HY8TqSPu9qczlpkT1AwzfqLnCwmlgc/vVGWvaWCMgNU9BLOJ52+7E/4uBCkA7jHRTxropL3WDMYEa5Zdc6FpyTN26vVSL5+XS6JDOzZEoqvl73YMtxCMPdcAiDK0lfDKklIIax8c/5Wpiq+T8=
Message-ID: <d66e87630701310634s385db5adwa82e2194188efa81@mail.gmail.com>
Date: Wed, 31 Jan 2007 09:34:54 -0500
From: "Eddie Pettis" <pettis.eddie@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: How to locate struct file * from a bio?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Short question:  Is it possible to locate the struct file * associated
with a bio?  If so, how?

Longer version:  I am working on a project that requires measuring the
popularity of each file in a filesystem.  I have made several attempts
to locate all the file reads by grepping for ->readpage() and
->readpages() calls, but I am still missing several file reads.  I
have not yet looked for file writes.

I *have* been able to catch every bio access, which leads to my
question.   Is it possible to locate the struct file * associated with
a bio?  If so, how?  Efficiency is not my primary issue right now.
I'm mainly concerned with it "just working."

Thanks in advance!

--

Eddie Pettis
Electrical and Computering Engineering
Purdue University
