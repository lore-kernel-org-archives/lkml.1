Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYGDG0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYGDG0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYGDG0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:26:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:19202 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYGDG0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=lak/UurKvsL5Rl99Sh6TJGlCJ3Chws59sg9oKag1uKlaZ7aEilNPJs87+0zxV1FO9T
         eBPUuCSsXw5RQhqOVnjsPfYFpTgGd3Q8Q/oeUVkvBSG6r2n863u/9GV8R0qScfWpw3pz
         noNhrWEWHTU73E2Ipwn8mVVnUmAQMxy781iyU=
Message-ID: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com>
Date: Fri, 4 Jul 2008 02:26:08 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tested this with 2.6.26-rc5-mm3 and with 2.6.26-rc8 w/ the
get_user_pages_fast patches from -rc5-mm3... Xorg 1.4.99.* will start
to load but hangs at a black screen. At this point, I can not switch
to another tty. When I try pressing ctrl+alt+del the kernel ooopses
and the caps lock led starts to blink. This happens using the nv,
radeon and radeonhd drivers (the nv was tested on another box
obviously). I have also tried to unselect HAVE_GET_USER_PAGES_FAST in
my kernel config but this does not help. I can not figure out where or
what the bug is. I can provide any other info you guys need to figure
this out. Let me know what I can do.

-Ryan
