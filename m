Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbZEYJua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbZEYJua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZEYJuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:50:22 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:53504 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbZEYJuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=PE0Aw24iy5RV/E6jaYVvFdbLGHIR2ROlztY8T2qkgUAJQqEGmBjqA+NAKtmgqf6odO
         qZ+iAmr4srgHVMNFV6TlQVYafuIJwj4GalWmC7RvX2cYPsK3rOVl/tWxd3/hxQMvtmsI
         oyfI+ilw9ea02ZtJXfxujhYhOJWpXyMpiDubE=
MIME-Version: 1.0
Date: Mon, 25 May 2009 12:50:22 +0300
Message-ID: <dfb262380905250250w2d689b28i25edc3d492b09676@mail.gmail.com>
Subject: serial device and fsync
From: Ramagudi Naziir <naziirr@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I need to write(2) a certain character to a serial device (using the
standard /dev/ttySx), and make sure it was transferred to the device
before I continue. I tried fsync(2), but that failed (does fsync even
apply to character devices or only block devices ?).

Any idea ?

Is it even possible or should I just usleep(500ms) after write(2) ? (I
know, it's ugly..).

Thanks in advance,
Naziir.
