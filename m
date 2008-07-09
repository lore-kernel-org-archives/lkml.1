Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYGISJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYGISJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYGISJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:09:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60527 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752116AbYGISJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:09:36 -0400
Message-ID: <4874FEDF.90404@sgi.com>
Date: Wed, 09 Jul 2008 11:09:35 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F30C.8020800@zytor.com> <4874F909.7060503@goop.org>
In-Reply-To: <4874F909.7060503@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Did the suspected linker bug issue ever get resolved?
> 
> I don't believe so.  I think Mike is getting very early crashes
> depending on some combination of gcc, linker and kernel config.  Or
> something.

Yes and unfortunately since SGI does not do it's own compilers any
more (they were MIPS compilers), there's no one here that really
understands the internals of the compile tools.

> 
> This fragility makes me very nervous.  It seems hard enough to get this
> stuff working with current tools; making it work over the whole range of
> supported tools looks like its going to be hard.

(me too ;-)

Once I get a solid version working with (at least) gcc-4.2.4, then
regression testing with older tools will be easier, or at least a
table of results can be produced.

Thanks,
Mike

