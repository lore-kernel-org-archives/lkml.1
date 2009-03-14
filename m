Return-Path: <linux-kernel-owner+w=401wt.eu-S1765781AbZCNCEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765781AbZCNCEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 22:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbZCNBWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:22:11 -0400
Received: from kroah.org ([198.145.64.141]:35832 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755397AbZCNBVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:21:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:48 2009
Message-Id: <20090314011048.025626220@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:11:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@redhat.com>
Subject: [patch 112/114] drm/i915: Add missing userland definitions for gem init/execbuffer.
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-add-missing-userland-definitions-for-gem-init-execbuffer.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Anholt <eric@anholt.net>

commit 8d391aa410ecb230fc4c3147b94eec25b9f3c20f upstream.

fdo bug #19132.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/drm/i915_drm.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -177,6 +177,8 @@ typedef struct _drm_i915_sarea {
 #define DRM_IOCTL_I915_SET_VBLANK_PIPE	DRM_IOW( DRM_COMMAND_BASE + DRM_I915_SET_VBLANK_PIPE, drm_i915_vblank_pipe_t)
 #define DRM_IOCTL_I915_GET_VBLANK_PIPE	DRM_IOR( DRM_COMMAND_BASE + DRM_I915_GET_VBLANK_PIPE, drm_i915_vblank_pipe_t)
 #define DRM_IOCTL_I915_VBLANK_SWAP	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_VBLANK_SWAP, drm_i915_vblank_swap_t)
+#define DRM_IOCTL_I915_GEM_INIT		DRM_IOW(DRM_COMMAND_BASE + DRM_I915_GEM_INIT, struct drm_i915_gem_init)
+#define DRM_IOCTL_I915_GEM_EXECBUFFER	DRM_IOW(DRM_COMMAND_BASE + DRM_I915_GEM_EXECBUFFER, struct drm_i915_gem_execbuffer)
 #define DRM_IOCTL_I915_GEM_PIN		DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GEM_PIN, struct drm_i915_gem_pin)
 #define DRM_IOCTL_I915_GEM_UNPIN	DRM_IOW(DRM_COMMAND_BASE + DRM_I915_GEM_UNPIN, struct drm_i915_gem_unpin)
 #define DRM_IOCTL_I915_GEM_BUSY		DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GEM_BUSY, struct drm_i915_gem_busy)


