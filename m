Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbZIVFmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbZIVFmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZIVFma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:42:30 -0400
Received: from dcent.unixwiz.net ([99.25.142.34]:48764 "EHLO dcent.unixwiz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbZIVFma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:42:30 -0400
Date: Mon, 21 Sep 2009 22:42:34 -0700
From: Steve Friedl <steve@unixwiz.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] staging: hv: Style only: moved the pointer-* next to the variable, not the type
Message-ID: <20090922054234.GA6001@dcent.unixwiz.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The style guide - and good common sense - puts the pointer-to derived
type next to the variable name it belongs with (rather than the type),
and this patch harmonizes the code to that style.

~~~ Steve

Signed-off-by: Steve Friedl <steve@unixwiz.net>

---
 drivers/staging/hv/RingBuffer.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/hv/RingBuffer.c b/drivers/staging/hv/RingBuffer.c
index c50c447..3428372 100644
--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -68,7 +68,7 @@ Description:
 
 --*/
 static inline u32
-GetNextWriteLocation(struct hv_ring_buffer_info* RingInfo)
+GetNextWriteLocation(struct hv_ring_buffer_info *RingInfo)
 {
 	u32 next = RingInfo->RingBuffer->WriteIndex;
 
@@ -87,7 +87,7 @@ Description:
 
 --*/
 static inline void
-SetNextWriteLocation(struct hv_ring_buffer_info* RingInfo, u32 NextWriteLocation)
+SetNextWriteLocation(struct hv_ring_buffer_info *RingInfo, u32 NextWriteLocation)
 {
 	RingInfo->RingBuffer->WriteIndex = NextWriteLocation;
 }
@@ -102,7 +102,7 @@ Description:
 
 --*/
 static inline u32
-GetNextReadLocation(struct hv_ring_buffer_info* RingInfo)
+GetNextReadLocation(struct hv_ring_buffer_info *RingInfo)
 {
 	u32 next = RingInfo->RingBuffer->ReadIndex;
 
@@ -122,7 +122,7 @@ Description:
 
 --*/
 static inline u32
-GetNextReadLocationWithOffset(struct hv_ring_buffer_info* RingInfo, u32 Offset)
+GetNextReadLocationWithOffset(struct hv_ring_buffer_info *RingInfo, u32 Offset)
 {
 	u32 next = RingInfo->RingBuffer->ReadIndex;
 
@@ -143,7 +143,7 @@ Description:
 
 --*/
 static inline void
-SetNextReadLocation(struct hv_ring_buffer_info* RingInfo, u32 NextReadLocation)
+SetNextReadLocation(struct hv_ring_buffer_info *RingInfo, u32 NextReadLocation)
 {
 	RingInfo->RingBuffer->ReadIndex = NextReadLocation;
 }
@@ -175,7 +175,7 @@ Description:
 
 --*/
 static inline u32
-GetRingBufferSize(struct hv_ring_buffer_info* RingInfo)
+GetRingBufferSize(struct hv_ring_buffer_info *RingInfo)
 {
 	return RingInfo->RingDataSize;
 }
@@ -190,7 +190,7 @@ Description:
 
 --*/
 static inline u64
-GetRingBufferIndices(struct hv_ring_buffer_info* RingInfo)
+GetRingBufferIndices(struct hv_ring_buffer_info *RingInfo)
 {
 	return ((u64)RingInfo->RingBuffer->WriteIndex << 32) || RingInfo->RingBuffer->ReadIndex;
 }
@@ -229,13 +229,13 @@ static u32
 CopyToRingBuffer(
 	struct hv_ring_buffer_info	*RingInfo,
 	u32				StartWriteOffset,
-	void *				Src,
+	void  				*Src,
 	u32				SrcLen);
 
 static u32
 CopyFromRingBuffer(
 	struct hv_ring_buffer_info	*RingInfo,
-	void *				Dest,
+	void 				*Dest,
 	u32				DestLen,
 	u32				StartReadOffset);
 
@@ -533,10 +533,10 @@ static u32
 CopyToRingBuffer(
 	struct hv_ring_buffer_info	*RingInfo,
 	u32				StartWriteOffset,
-	void *				Src,
+	void  				*Src,
 	u32				SrcLen)
 {
-	void * ringBuffer=GetRingBuffer(RingInfo);
+	void *ringBuffer=GetRingBuffer(RingInfo);
 	u32 ringBufferSize=GetRingBufferSize(RingInfo);
 	u32 fragLen;
 
@@ -573,11 +573,11 @@ Description:
 static u32
 CopyFromRingBuffer(
 	struct hv_ring_buffer_info	*RingInfo,
-	void *				Dest,
+	void 				*Dest,
 	u32				DestLen,
 	u32				StartReadOffset)
 {
-	void * ringBuffer=GetRingBuffer(RingInfo);
+	void *ringBuffer=GetRingBuffer(RingInfo);
 	u32 ringBufferSize=GetRingBufferSize(RingInfo);
 
 	u32 fragLen;
-- 
1.6.5.rc1
