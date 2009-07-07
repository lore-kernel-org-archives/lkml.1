Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbZGGPiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbZGGPiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbZGGPir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:38:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51409 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbZGGPiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:38:46 -0400
Message-ID: <4A536BCC.6030504@zytor.com>
Date: Tue, 07 Jul 2009 08:37:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexey Vlasov <renton@renton.name>
CC: Ray Lee <ray-lk@madrabbit.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: devpts mounts too slowly
References: <20090603142801.GC21646@beaver.vrungel.ru> <4A26EB18.6060907@zytor.com> <20090609161945.811cc01f.akpm@linux-foundation.org> <2c0942db0906091630l1cc79647h8689e9e929ed1bba@mail.gmail.com> <4A2EF833.6080300@zytor.com> <20090706195252.GA7484@beaver.vrungel.ru> <4A526AEF.3070407@zytor.com> <20090707083853.GC7484@beaver.vrungel.ru>
In-Reply-To: <20090707083853.GC7484@beaver.vrungel.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Vlasov wrote:
> On Mon, Jul 06, 2009 at 02:21:51PM -0700, H. Peter Anvin wrote:
>> Do you have /selinux mounted on one of them?
> 
> I don't use SELinux anywhere.
> 

That's, apparently, the problem: some version of the mount binary will
search all of /proc/mounts for selinux if it isn't mounted on /selinux.
 This is a serious performance bug, obviously.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

