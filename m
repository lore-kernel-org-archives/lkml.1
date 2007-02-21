Return-Path: <linux-kernel-owner+w=401wt.eu-S964822AbXBUBzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbXBUBzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965076AbXBUBwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:52:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:35826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964838AbXBUBwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:52:09 -0500
Date: Tue, 20 Feb 2007 17:50:47 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 11/18] v4l: cx2341x audio_properties is an u16, not u8
Message-ID: <20070221015047.GL3684@kroah.com>
References: <20070221014413.282048309@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-cx2341x-audio_properties-is-an-u16-not-u8.patch"
In-Reply-To: <20070221014927.GA3684@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Hans Verkuil <hverkuil@xs4all.nl>

This bug broke the MPEG audio mode controls.

(cherry picked from commit cb2c7b4927c8f376b7ba9557978d8c59ed472664)

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/media/cx2341x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.18.7.orig/include/media/cx2341x.h
+++ linux-2.6.18.7/include/media/cx2341x.h
@@ -49,7 +49,7 @@ struct cx2341x_mpeg_params {
 	enum v4l2_mpeg_audio_mode_extension audio_mode_extension;
 	enum v4l2_mpeg_audio_emphasis audio_emphasis;
 	enum v4l2_mpeg_audio_crc audio_crc;
-	u8 audio_properties;
+	u16 audio_properties;
 
 	/* video */
 	enum v4l2_mpeg_video_encoding video_encoding;

--
