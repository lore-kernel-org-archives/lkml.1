Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZBMMfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZBMMfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZBMMe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:34:56 -0500
Received: from 1wt.eu ([62.212.114.60]:2226 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbZBMMez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:34:55 -0500
Date: Fri, 13 Feb 2009 13:34:49 +0100
From: Willy Tarreau <w@1wt.eu>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.16] NULL pointer dereference at show_docked()
Message-ID: <20090213123449.GP5038@1wt.eu>
References: <200902132045.FFG87556.OFSFOMHFVJQtLO@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902132045.FFG87556.OFSFOMHFVJQtLO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 13, 2009 at 08:45:21PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I encountered this on Ubuntu 8.04 on ThinkPad X60 with a dockable station
> docked. The dockable station's removable slot holds a HDD.
> 
> Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.27.16 .
> Full log is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.27.16-native.txt .
> 
> ----------------------------------------
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<c051f9e3>] show_docked+0xe/0x37

already reported and fixed in 2.6.27.17.

Regards,
Willy

