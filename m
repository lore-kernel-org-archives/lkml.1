Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbZAGOjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbZAGOjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbZAGOiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:38:52 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:35054 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZAGOiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:38:52 -0500
Message-Id: <4964CCA5.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 07 Jan 2009 14:39:17 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Theodore Tso" <tytso@mit.edu>
Cc: <ccache@lists.samba.org>, "Sam Ravnborg" <sam@ravnborg.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Recent change to kernel spikes out
	 ccache/distcc
References: <E1LKDeQ-0002xz-7E@closure.thunk.org>
 <20090107131221.GA17110@mit.edu> <4964BEAA.76E4.0078.0@novell.com>
 <20090107142854.GB17110@mit.edu>
In-Reply-To: <20090107142854.GB17110@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Theodore Tso <tytso@mit.edu> 07.01.09 15:28 >>>
>On Wed, Jan 07, 2009 at 01:39:38PM +0000, Jan Beulich wrote:
>> >>> Theodore Tso <tytso@mit.edu> 07.01.09 14:12 >>>
>> >objcopy: not stripping symbol `__ksymtab_strings' because it is named in a relocation
>> 
>> Another thing I've never seen in any of my builds - these strings always
>> get relocations against the corresponding section symbol.
>
>Just to be clear; it doesn't always fail; it seems to be random (or at
>least, I haven't had time to try to suss out why sometimes
>__ksymtab_strings is being used in a relocation):

It's apparently happening only for modules which export symbols.

Jan

