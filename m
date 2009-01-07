Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbZAGNHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbZAGNHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZAGNHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:07:45 -0500
Received: from adelie.canonical.com ([91.189.90.139]:53227 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZAGNHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:07:44 -0500
Date: Wed, 7 Jan 2009 13:07:42 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: davej@redhat.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: scripts/checkpatch.pl : undefined value as an ARRAY reference
Message-ID: <20090107130742.GD2520@shadowen.org>
References: <3f9a31f40901070454x678f75d2xee2a6de04a940321@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901070454x678f75d2xee2a6de04a940321@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 06:24:55PM +0530, Jaswinder Singh Rajput wrote:
> Hello Andy,
> 
> On -tip git I am getting this error:
> 
> $ ./scripts/checkpatch.pl 000*
> Can't use an undefined value as an ARRAY reference at
> ./scripts/checkpatch.pl line 451.
> 
> But earlier it was working great. Is this a feature or a bug.

That looks wrong indeed.  Assuming that is the same version I have here
then that is a bug in the #else preprocessor handling.  Could you send
me the specific patch which is throwing this error.

Thanks.

-apw
