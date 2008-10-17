Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbYJQCqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbYJQCqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 22:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYJQCqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 22:46:04 -0400
Received: from willie.n0ano.com ([64.66.241.76]:56511 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752074AbYJQCqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 22:46:03 -0400
From: n0ano@n0ano.com
Date: Thu, 16 Oct 2008 20:45:44 -0600
To: Yinghai Lu <yinghai@kernel.org>
Cc: n0ano@n0ano.com, Paul Bolle <pebolle@tiscali.nl>,
       donald.d.dugger@intel.com, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Enable console on PCI serial devices
Message-ID: <20081017024544.GB9378@xolotl.n0ano.com>
References: <86802c440810141539x97ceaa4meaab109fae3d9d4c@mail.gmail.com> <20081014233031.GB14490@xolotl.n0ano.com> <1224061999.25929.7.camel@test.thuisdomein> <20081015204850.GC14490@xolotl.n0ano.com> <1224153822.3587.23.camel@test.thuisdomein> <48F76A8B.6050306@kernel.org> <20081016171218.GD14490@xolotl.n0ano.com> <48F785B0.7000008@kernel.org> <20081016182556.GE14490@xolotl.n0ano.com> <86802c440810161130x304128faj6b1a1a6e1b90ed03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810161130x304128faj6b1a1a6e1b90ed03@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 11:30:17AM -0700, Yinghai Lu wrote:
>... 
> but if someone don't need the switch from early console to normal console...
> 

When would that ever be useful?  I can understand wanting early printks
and normal console printks going to the serial device.  I can understand
wanting neither to go to serial.  I just don't see why you would ever
want the early printks to go to serial and then stop using the serial
for normal console printks, that just doesn't make sense.

-- 
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
n0ano@n0ano.com
Ph: 303/443-3786
