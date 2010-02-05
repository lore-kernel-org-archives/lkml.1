Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab0BEAmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 19:42:40 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:20971 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab0BEAmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 19:42:38 -0500
Date: Thu, 4 Feb 2010 16:42:36 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915 oops on 2.6.33-rc6
Message-ID: <20100205004236.GA10885@hexapodia.org>
References: <4B6B17D2.4090307@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6B17D2.4090307@oracle.com>
User-Agent: Mutt/1.4.2.3i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 01:54:10PM -0500, Chuck Lever wrote:
> Pulled from Linus' git repo yesterday, and got this on a Dell Latitude 
> D620, on every boot since then.  Updated to latest a couple of hours 
> ago, and still seeing it.  kernel config and lspci output attached.
> 
> I'm not subscribed to lkml, please ensure I'm in the cc: or to: field on 
> relevant replies.
> 
> 
> Feb  4 13:17:43 monet kernel: [drm:i915_gem_do_execbuffer] *ERROR* 
> Invalid object handle 1073741824 at index 3

This isn't quite the same symptom everyone else is seeing, but DRM
having object handle problems makes me wonder if you're running into

http://lkml.org/lkml/2010/2/3/415
http://lkml.org/lkml/2010/2/3/463

Does reverting 859ddf09743a8cc680af33f7259ccd0fd36bfe9d help?

-andy
