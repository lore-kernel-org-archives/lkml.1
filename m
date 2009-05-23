Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbZEWS3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbZEWS3f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 14:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbZEWS33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 14:29:29 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:46694 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbZEWS32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 14:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=B79iaXiC++NhA24rHVnjs6Z6j44W2aMpyFi+3W+GJqtTFSKmLe34dosETNkXx5gTIY
         Hjb6LYJxtgUobUX1OnvCSWXrlxZapa9dgoas1xWbb1504fljT3Ry1aoEfre00peYicKl
         8WJV4ezhTwU6U2oLiMbdkPlL+23WkIEMODArU=
MIME-Version: 1.0
Date: Sat, 23 May 2009 11:29:29 -0700
Message-ID: <dd18b0c30905231129j7ad812e9sf3eee89864b03fb8@mail.gmail.com>
Subject: running the kernel without hal= how safe with the cpufreq
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm in the process of building a system
minus hal(since udev 142 explains itself
in the README),
Anyways I normally just have
"ondemand" compiled as the main
cpufreq module, and have no powermgnt or cpufreq
userspace tool except or was hal.
should I be concerned
without having hal due to things like this in
ps auxZ

/usr/libexec/hald-addon-macbookpro-backlight
/usr/libexec/hald-addon-cpufreq

will the kernel take charge of the cores
or do I need to find a userspace app
to keep them at a safe level?

-- 
Justin P. Mattock
