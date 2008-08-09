Return-Path: <linux-kernel-owner+w=401wt.eu-S1761618AbYHIBWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618AbYHIBWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYHIBWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:22:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37712 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbYHIBWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:22:31 -0400
Date: Sat, 9 Aug 2008 03:23:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs v0.16 released
Message-ID: <20080809012322.GF9038@one.firstfloor.org>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com> <20080808215625.GC9038@one.firstfloor.org> <20080809011905.GB9967@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080809011905.GB9967@mit.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In theory, if the elevator was smart enough, it could actually help
> read seekiness; there are two copies of the metadata, and it shouldn't

That assumes the elevator actually knows what is nearby? I thought
that wasn't that easy with modern disks with multiple spindles
and invisible remapping, not even talking about RAID
arrays looking like disks.

-Andi
