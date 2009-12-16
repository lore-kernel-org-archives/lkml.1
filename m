Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbZLPSA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbZLPSA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbZLPSA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:00:27 -0500
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:43363 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753491AbZLPSA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:00:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=A8iErSfR5PBz2APy/ius4SIQIU2kLLif7mu/mlTc0xFfPuVYtqidviZpc+HQVU7o+G+IXWKXB+yNYqC31C0Ej4HHQLtcd5Oz6ZqRtFsI794RBGIqvl+CgL/nXAzrOnjw;
Date: Wed, 16 Dec 2009 10:00:05 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: Dave Airlie <airlied@linux.ie>, Jeff Mahoney <jeffm@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fb/intelfb: Do not depend on EMBEDDED
Message-ID: <20091216100005.2c7e6d69@jbarnes-piketon>
In-Reply-To: <200912161437.32134.jdelvare@suse.de>
References: <aa541tsbrtanvarunansa3uh.1260654940760@email.android.com>
	<200912131250.13797.jdelvare@suse.de>
	<alpine.DEB.2.00.0912132148550.24123@skynet.skynet.ie>
	<200912161437.32134.jdelvare@suse.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 14:37:31 +0100
Jean Delvare <jdelvare@suse.de> wrote:
> If I wanted to attempt a transparent migration, where would I start?
> As I recall, console on framebuffer needs specific boot parameters,
> right? I don't suppose that kms will transparently pick them and do
> the right thing, do I? If there documentation available on how one
> can get a high resolution console using kms?

Actually, that's one of the big advantages of the KMS based driver.  It
*does* transparently pick the native resolution of the detected
output(s) and set up a high res console.  You can provide boot options
to override it, but unlike intelfb, boot options aren't necessary to
get things working in the first place.

If you want to run X later, you'll need an updated xf86-video-intel
(preferably 2.9.x) or xf86-video-radeon driver as well, since code to
support the KMS interfaces landed only slightly before 2.6.29 came out
in the case of Intel.

-- 
Jesse Barnes, Intel Open Source Technology Center
