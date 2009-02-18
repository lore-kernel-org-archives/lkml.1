Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbZBRXtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbZBRXtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 18:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZBRXtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 18:49:11 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:12035 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbZBRXtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 18:49:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=bCO25SdO59kWAhUBYhkljQbMyqDn+L928JqbcHw1qLsGPXKwNuDyUHJLR0vHjgXBdb
         cgStJYCb/hEki2ssNpOcTs8LOvnuRCLom7DCjwE1ifcUl0OKyui5WxKCEeOFtvBTTQ1k
         N4H8Dx0Rf1ZuvnSmRy/4xLu+K7ZTeyIPkVqUE=
MIME-Version: 1.0
Date: Wed, 18 Feb 2009 15:49:09 -0800
Message-ID: <79759ec90902181549t292d1adco55416c04366afdad@mail.gmail.com>
Subject: How do you profile an executable that loads shared libraries?
From: Scott Simpson <simpson100@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an executable that loads shared libraries. I compiled with "-g
-pg" and then I ran gprof on the gmon.out file. I don't see any of the
shared libraries that the program loaded in my gprof output. How do
you profile shared libraries?

Also, I saw on the ld.so man page the LD_PROFILE variable but I found
information on the net that says variable should not be used when
using -pg.

Can someone help me out? I can't find information *anywhere* on
profiling shared libraries using gprof or the LD_PROFILE variable.

Sorry to post here. I don't know where else to post.
