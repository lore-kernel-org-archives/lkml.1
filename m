Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0BLLYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:24:42 -0500
Received: from ix.technologeek.org ([213.41.157.215]:34342 "EHLO
	sonic.technologeek.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755059Ab0BLLYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:24:40 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Feb 2010 06:24:40 EST
From: Julien BLACHE <jb@jblache.org>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: mjg@redhat.com, nicolas@boichat.ch, felipe_alfaro@linuxmail.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Brightness control for MacBook Pro - Nvidia 9400
References: <1265920725.7103.7.camel@no>
Date: Fri, 12 Feb 2010 12:18:28 +0100
In-Reply-To: <1265920725.7103.7.camel@no> (Soeren Sonnenburg's message of
	"Thu, 11 Feb 2010 21:38:45 +0100")
Message-ID: <878wayk8hn.fsf@sonic.technologeek.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sonnenburg <sonne@debian.org> wrote:

Hi,

> I am booting a MacBookPro5,3 using elilo and efifb. Now I'd like to use
> pommed to control display brightness (which won't work). Digging around
> in mbp_nvidia_bl.c I figured out that tries to control the geforce 9600M
> instead of the currently active geforece 9400m

If you know how one can determine which GPU is active, let me know. I
don't have this information at the moment.

> Does anyone have an idea which bytes to tweak to change brightness
> levels for the 9400? Seems like 0x52f does not work - at least
> setpci -s 03:00.0 0x52f.B=10 fails...

I'm not sure this method actually works without the legacy BIOS. IIRC
that method was determined by reverse engineering the Windows drivers,
which means the legacy BIOS was in use.

JB.

-- 
Julien BLACHE                                   <http://www.jblache.org> 
<jb@jblache.org>                                  GPG KeyID 0xF5D65169
