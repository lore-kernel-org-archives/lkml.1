Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbZAGMew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbZAGMew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbZAGMeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:34:44 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:29513 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZAGMen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:34:43 -0500
Message-Id: <4964AF8D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 07 Jan 2009 12:35:09 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: <ccache@lists.samba.org>, "Theodore Tso" <tytso@mit.edu>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Recent change to kernel spikes out
	 ccache/distcc
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
 <496386EF.76E4.0078.0@novell.com> <20090106173300.GA10903@mit.edu>
 <49647B00.76E4.0078.0@novell.com>
 <20090107113138.GA29730@uranus.ravnborg.org>
In-Reply-To: <20090107113138.GA29730@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Sam Ravnborg <sam@ravnborg.org> 07.01.09 12:31 >>>
>What is the gain/pain ratio here?

Certainly depends on the pov - it reduces the kernel module (disk) image
sizes quite a bit, so from a distro perspective its a move against the ever
growing package sizes (and the disk space) hundreds or even thousands
of modules require.

>Would it be a possibility to drop stripping off the
>crc symbols and go back to the ld method that
>is more ccache friendly?

That's certainly a possibility, but I have to admit that I'd like to keep the
option - a respective config option could default to 'no' if the build issues
are considered more significant. I'm really not that much worried about
adding another config parameter here...

>We would still benefir from all the other stripping done - no?

Yes.

Jan

