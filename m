Return-Path: <linux-kernel-owner+w=401wt.eu-S1765728AbXGQJLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765728AbXGQJLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 05:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbXGQJLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 05:11:45 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:10823 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbXGQJLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 05:11:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Pgav2hz4LrETXcyqEgeQ+r3I3qeXrj1FmNRbhMy7ZnHL4r/RVC0CgIsK8PsdCAzXVwwHtCrZy9KZ6aYKYN9TXruW8uKDj3cPHzgiFKV7HNmAYmFPSm7Pc10Q0syCTJDSuo//Rr4KiEN+50x1ozp3FQGGbtfBOoB3c88nRy+Tnwk=
Message-ID: <6cf66ee10707170211t62714949me975656143e7b710@mail.gmail.com>
Date: Mon, 16 Jul 2007 23:11:41 -1000
From: "charles gagalac" <charles.gagalac@gmail.com>
To: airlied@linux.ie
Subject: [BUG] wine locks up system
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

starting an application under wine 0.9.41 locks up my system.  bisect
generated the following commit:

 commit d4e2cbe9cb9219fc924191a6baa2369140cb5ea8
  Author: Dave Airlie <airlied@linux.ie>
 Date:   Tue Jul 17 10:55:47 2007 +1000

     drm: convert drawable code to using idr

     This converts the code for allocating drawables to the Linux idr,

     Fixes from: Michel Dänzer <michel@tungstengraphics.com>,
Kristian Høgsberg <krh@redhat.com>

     Signed-off-by: Dave Airlie <airlied@linux.ie>
