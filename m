Return-Path: <linux-kernel-owner+w=401wt.eu-S1750907AbZGSEBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907AbZGSEBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 00:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbZGSEBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 00:01:46 -0400
Received: from koti.tapanitarvainen.fi ([217.112.255.16]:58056 "EHLO
	musti.tarvainen.info" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750715AbZGSEBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 00:01:45 -0400
X-Greylist: delayed 986 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Jul 2009 00:01:44 EDT
Date: Sun, 19 Jul 2009 06:44:36 +0300
From: Tapani Tarvainen <tapani@tapanitarvainen.fi>
To: device-mapper development <dm-devel@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: How to handle >16TB devices on 32 bit hosts ??
Message-ID: <20090719034436.GA27328@musti.tarvainen.info>
References: <19041.4714.686158.130252@notabene.brown> <20090718043155.GI4231@webber.adilger.int> <871voewm6y.fsf@basil.nowhere.org> <20090718065213.GK4231@webber.adilger.int> <20090718074811.GA2682@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090718074811.GA2682@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 09:48:11AM +0200, Andi Kleen (andi@firstfloor.org) wrote:
> On Sat, Jul 18, 2009 at 02:52:13AM -0400, Andreas Dilger wrote:
> > If you aren't running a 32-bit system with this config, you shouldn't
> > really care.  For those systems that need to run in this mode they
> > would rather have it work a few percent slower instead of not at all.
> 
> Well, it doesn't work at all anyways due to the fsck problem.

I can imagine several scenarios where 16TB+ raid would be useful
without any filesystems bigger than 2TB.
Or does LVM have problems with 16TB+ devices in 32bit-systems, too?

-- 
Tapani Tarvainen
