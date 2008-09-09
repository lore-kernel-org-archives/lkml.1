Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYIIHic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYIIHic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYIIHiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:38:24 -0400
Received: from hs-out-0708.google.com ([64.233.178.242]:4003 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbYIIHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:38:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=qR6e6N6P1Z7GaiOQNGbXy+MaVrQ0TYKyqf6cqetUp8nny71IJdyVKT+ECWdz7CTS4h
         mnrma88uRLgDPQjXziJntJvzJ9oX39ACFzN844Inbqf8Oe92ikhJPzb+KoQPyJ63bYeR
         /c4VXVQcsVY30YZMCBzLnKSB+uUJeCEO9X7Ik=
Message-ID: <b153a4720809090038n361997a9j77a29844d871d9fa@mail.gmail.com>
Date: Tue, 9 Sep 2008 13:08:22 +0530
From: "santi mondal" <santismiles4u@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: const struct file_operations struct definition
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I was trying to build a kernel module to block all the writes
happening to a particular disk/mount point (multiple disk/mount points
at the same time). To achieve this I tried to replace the
file_operations->write function pointer. Since it is defined as
"const", replacing it is not poissible. Is there any way outs to get
the control in the filesystem's write funtion ?

It would be of great help if anybody could throw some ideas.

Sorry for sending the e-mail without subscribing to the list. Please
cc me while replying back to this e-mail.

thanks
-santi
