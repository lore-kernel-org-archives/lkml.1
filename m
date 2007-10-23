Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbXJWJ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbXJWJ6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbXJWJ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:58:05 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47881
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751848AbXJWJ6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:58:02 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] Add table IDs to videobook.tmpl
Date: Tue, 23 Oct 2007 04:57:28 -0500
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, alan@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710230457.28760.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add table IDs to videobook.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/DocBook/videobook.tmpl |   34 ++++++++++++-------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -r a868e8217782 Documentation/DocBook/videobook.tmpl
--- a/Documentation/DocBook/videobook.tmpl	Mon Oct 22 19:40:02 2007 -0700
+++ b/Documentation/DocBook/videobook.tmpl	Mon Oct 22 23:34:11 2007 -0500
@@ -178,7 +178,7 @@ int __init myradio_init(struct video_ini
   <para>
         The types available are
   </para>
-   <table frame="all"><title>Device Types</title>
+   <table frame="all" id="Device_Types"><title>Device Types</title>
    <tgroup cols="3" align="left">
    <tbody>
    <row>
@@ -299,7 +299,7 @@ static int radio_ioctl(struct video_devi
         allows the applications to find out what sort of a card they have found and
         to figure out what they want to do about it. The fields in the structure are
   </para>
-   <table frame="all"><title>struct video_capability fields</title>
+   <table frame="all" id="video_capability_fields"><title>struct video_capability fields</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -373,7 +373,7 @@ static int radio_ioctl(struct video_devi
   <para>
         The video_tuner structure has the following fields
   </para>
-   <table frame="all"><title>struct video_tuner fields</title>
+   <table frame="all" id="video_tuner_fields"><title>struct video_tuner fields</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -406,7 +406,7 @@ static int radio_ioctl(struct video_devi
     </tgroup>
     </table>
 
-   <table frame="all"><title>struct video_tuner flags</title>
+   <table frame="all" id="video_tuner_flags"><title>struct video_tuner flags</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -429,7 +429,7 @@ static int radio_ioctl(struct video_devi
     </tgroup>
     </table>
 
-   <table frame="all"><title>struct video_tuner modes</title>
+   <table frame="all" id="video_tuner_modes"><title>struct video_tuner modes</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -580,7 +580,7 @@ static int current_volume=0;
   <para>
         Then we fill in the video_audio structure. This has the following format
   </para>
-   <table frame="all"><title>struct video_audio fields</title>
+   <table frame="all" id="video_audio_fields"><title>struct video_audio fields</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -615,7 +615,7 @@ static int current_volume=0;
    </tgroup>
    </table>
 
-   <table frame="all"><title>struct video_audio flags</title>
+   <table frame="all" id="video_audio_flags"><title>struct video_audio flags</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -633,7 +633,7 @@ static int current_volume=0;
    </tgroup>
    </table>
 
-   <table frame="all"><title>struct video_audio modes</title>
+   <table frame="all" id="video_audio_modes"><title>struct video_audio modes</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -783,7 +783,7 @@ module_exit(cleanup);
   </para>
   </sect1>
   </chapter>
-  <chapter>
+  <chapter id="Video_Capture_Devices">
         <title>Video Capture Devices</title>
   <sect1 id="introvid">
   <title>Video Capture Device Types</title>
@@ -864,7 +864,7 @@ static struct video_device my_camera
         We use the extra video capability flags that did not apply to the
         radio interface. The video related flags are
   </para>
-   <table frame="all"><title>Capture Capabilities</title>
+   <table frame="all" id="Capture_Capabilities"><title>Capture Capabilities</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -1204,7 +1204,7 @@ static int camera_ioctl(struct video_dev
         inputs to the video card). Our example card has a single camera input. The
         fields in the structure are
   </para>
-   <table frame="all"><title>struct video_channel fields</title>
+   <table frame="all" id="video_channel_fields"><title>struct video_channel fields</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -1227,7 +1227,7 @@ static int camera_ioctl(struct video_dev
     </tbody>
     </tgroup>
     </table>
-    <table frame="all"><title>struct video_channel flags</title>
+    <table frame="all" id="video_channel_flags"><title>struct video_channel flags</title>
     <tgroup cols="2" align="left">
     <tbody>
     <row>
@@ -1238,7 +1238,7 @@ static int camera_ioctl(struct video_dev
     </tbody>
     </tgroup>
     </table>
-    <table frame="all"><title>struct video_channel types</title>
+    <table frame="all" id="video_channel_types"><title>struct video_channel types</title>
     <tgroup cols="2" align="left">
     <tbody>
     <row>
@@ -1251,7 +1251,7 @@ static int camera_ioctl(struct video_dev
     </tbody>
     </tgroup>
     </table>
-    <table frame="all"><title>struct video_channel norms</title>
+    <table frame="all" id="video_channel_norms"><title>struct video_channel norms</title>
     <tgroup cols="2" align="left">
     <tbody>
     <row>
@@ -1337,7 +1337,7 @@ static int camera_ioctl(struct video_dev
         for every other pixel in the image. The other common formats the interface 
         defines are
   </para>
-   <table frame="all"><title>Framebuffer Encodings</title>
+   <table frame="all" id="Framebuffer_Encodings"><title>Framebuffer Encodings</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -1475,7 +1475,7 @@ static struct video_buffer capture_fb;
         display. The video_window structure is used to describe the way the image 
         should be displayed. 
    </para>
-   <table frame="all"><title>struct video_window fields</title>
+   <table frame="all" id="video_window_fields"><title>struct video_window fields</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>
@@ -1512,7 +1512,7 @@ static struct video_buffer capture_fb;
     <para>
         Each clip is a struct video_clip which has the following fields
    </para>
-   <table frame="all"><title>video_clip fields</title>
+   <table frame="all" id="video_clip_fields"><title>video_clip fields</title>
    <tgroup cols="2" align="left">
    <tbody>
    <row>

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
