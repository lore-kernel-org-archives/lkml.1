Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbZJDWdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbZJDWdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 18:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZJDWdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 18:33:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:56961 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZJDWdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 18:33:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=SYpcNpYvnUyIyec5SFhHLLD3G+yKYoSzBaFebgrS+HfTL+qs3XkEWoNXRCVLI1uPIb
         a2i859QCKOJoQEBlnpQQhymJAuVBdgljvN1gkrD8WdWFvDmUxe5tHxxhuHrkv2lME4KZ
         JYqr8lDPVoqQFqKUIPHZ50T8c3+toOiPaaxa8=
MIME-Version: 1.0
Date: Mon, 5 Oct 2009 01:31:32 +0300
Message-ID: <94a0d4530910041531o2ef8e9a8lacddc817674f563d@mail.gmail.com>
Subject: Ripary visualization of 2.6.31
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ripary[1] is the new name (previously codeswarm.rb) of my project to
create a codeswarm clone in Ruby. In order to make it public I made a
new release and generated a video to visualize the 2.6.31 development.

Here it is:
http://www.youtube.com/watch?v=8rZYP2_itFk

The commits appear when the author created them, and each time that
happens the author is highlighted and the gravity increased. The same
happens with files, so if two people touch similar files they should
be close together. As time goes by, if there's no activity the authors
fade away.

The color map:

 * documentation: yellow
 * core: blue
 * drivers: magenta
 * arch: cyan
 * rest of c code: green
 * other: red

Ripary doesn't have problems rendering the history of most projects,
but the activity of the linux kernel was just too much, the current
algorithms took a looong time to finish (~1 day). Hopefully those will
get improved soon. Oh, and unfortunately YouTube is stripping too much
quality out of the video :(

Enjoy :)

[1] https://sourceforge.net/projects/ripary/

-- 
Felipe Contreras
