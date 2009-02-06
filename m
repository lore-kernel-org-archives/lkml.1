Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZBFXkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZBFXkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 18:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbZBFXkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 18:40:42 -0500
Received: from outbound-mail-13.bluehost.com ([69.89.18.113]:44679 "HELO
	outbound-mail-13.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755762AbZBFXkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 18:40:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=c7vJFqDdjKnSCqUSXoMXD5PS7pNun729cPaWGKV8BZ2f/n/Jo5ncHDhzlEeUecmtF/cy9TVts5jNY6+tM5/wUeCmu+LdrVb40zb5rFU30D3ixCW3DdK9s5MZFkVlA9Ia;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [Bug #12491] i915 lockdep warning
Date: Fri, 6 Feb 2009 15:40:34 -0800
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>,
       drivers_video-dri@kernel-bugs.osdl.org
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <200902050203.40535.rjw@sisk.pl> <adar62bchfw.fsf@cisco.com>
In-Reply-To: <adar62bchfw.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902061540.38042.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 6, 2009 2:46 pm Roland Dreier wrote:
>  > i915: Fix potential AB-BA deadlock in i915_gem_execbuffer()
>
> Jesse, Eric, or anybody -- does this look correct to you?  This seems to
> be triggering for several people, eg
> https://bugzilla.redhat.com/show_bug.cgi?id=481687

Eric's been looking at this issue, and there's some discussion about it on the 
intel-gfx list, but I'm not sure what the latest is (Eric is travelling atm).

-- 
Jesse Barnes, Intel Open Source Technology Center
