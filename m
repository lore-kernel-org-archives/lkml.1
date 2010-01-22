Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020Ab0AVBFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0AVBFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408Ab0AVBFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:05:52 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:17685 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0AVBFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:05:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vwBvs7GyyUpWMgfmzRWd9RSmKQUYqRUVphsoFRGaOczhKVjeexmJXjjK6RTIQK14zQ
         FK9A8rS79/N6OHB6s23kbA8Yx7JgBFHPqbI+UYA7L/hLePWF6EhrkfgSfPL03Xgtk4y9
         kEhG3vCtJwgcq9IOHRzsDvA608+iW05Wg8hcg=
MIME-Version: 1.0
Date: Fri, 22 Jan 2010 02:05:50 +0100
Message-ID: <22d9728d1001211705i4cf90df2ha730061ea01972b6@mail.gmail.com>
Subject: Hi all, bug or design flaw?
From: Stepan Chatalyan <kehcho@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I'm Stepan G. Chatalyan, and i think that I discovered a bug or design
flaw... and I don't know that it is provide from kernel...

Let's see:

(1) I mount /tmp with noexec,nosuid,nodev options

/dev/hda6 on /tmp type ext3 (rw,noexec,nosuid,nodev,relatime)

(2) I went to 'cd /tmp'`and I created a bash script, or another script
(perl, python, etc)... and chmod +x createdfile
script cointain:

#!/bin/bash
echo "Probe..."

(3) I tried to execut it with "./createdfile"
[kehcho@kehcho] [/tmp]$ ./createdfile
-bash: ./createdfile: /bin/bash: bad interpreter: Permission denied

(4) I tried to execute it, but pass to bash ". /tmp/createdfile"

[kehcho@tornadowt] [/tmp]$ . /tmp/createdfile
Probe...

It is a kernel bug or I just report a another one?

BB

-- 
Regards
