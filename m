Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZBCI2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZBCI2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZBCI2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:28:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:59266 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZBCI2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:28:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Pin1T0SV4wjmpWbt1x8jjWD3Rn7o7qw+elPJ/WELNJxXZqmbf4xI+camwCL65XnKzK
         fEj7F8/WJDa+vcDuqB8nHupXA8oFXHdW2Auf/kiCnPwAt8QIevIz4YJ7IV6yoIA2zTEn
         +Ww18jcdTr7V3IRT8Zju9Psgl0dj3le5dEfew=
MIME-Version: 1.0
Date: Tue, 3 Feb 2009 10:28:44 +0200
Message-ID: <ab4346860902030028p5798d4afi8aec5c2fd5fc83e0@mail.gmail.com>
Subject: [kernel make system] adding pre-check scripts
From: Victoria Muntean <vikimun@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there provision in kernel makefiles to execute user-supplied
pre/post add-on scripts ? (by following some convention)

I have script pre-checks.sh, it checks that .config defines certain parameters
certain way. This is to prevent [build with] accidental redefine of
certain important parameters.

One possibility is to
               ./my-pre-checks.sh && make
But this is not perfect.
It leaves of pre-checks optional easy to forget to run before build.
Is it possible to make "make" execute my pre-script before build.

Thanks
V.M.
