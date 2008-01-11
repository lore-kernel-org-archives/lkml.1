Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbYAKFWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbYAKFWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 00:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYAKFV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 00:21:57 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:59553 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYAKFV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 00:21:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OHo5XoXcgkI1i1rDwVLKC7tm68OOm01aOv2WrSzZNsk3VMRNNtmJT+zV6b07169knaMNKMdojYngsUYXEfCkAlKFQIHd4WZO8Z8VuDdNQB4Dwoh4x9/Fp0g5bhaNjVjx/gwtq0Xe4+9lsKkeAxOlKLYogtMoxQOsFNtbeZBVo6Y=
Message-ID: <aa79d98a0801102121h785dabc1y1d8982994d024eff@mail.gmail.com>
Date: Fri, 11 Jan 2008 08:21:55 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
Subject: Re: More breakage in native_rdtsc out of line in git-x86
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4d8e3fd30801091537l440e396cu481093e74f0da479@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080109035534.GA30321@basil.nowhere.org>
	 <20080109152208.GA21280@elte.hu>
	 <20080109155124.GB12923@one.firstfloor.org>
	 <20080109163017.GG17739@elte.hu>
	 <20080109174800.GA15346@one.firstfloor.org>
	 <20080109220948.GA2218@atjola.homenet>
	 <20080109222804.GF15612@one.firstfloor.org>
	 <1199918155.6424.71.camel@brick>
	 <20080109224142.GB18480@one.firstfloor.org>
	 <4d8e3fd30801091537l440e396cu481093e74f0da479@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 10, 2008 2:37 AM, Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
> On 1/10/08, Andi Kleen <andi@firstfloor.org> wrote:
>
> > I'm already cloning the branches; the problem is not getting conflicts etc.
> > when updating.
>
> Isn't git pull --force what you are looking for?
>
> Ciao,
> --
> Paolo
> http://paolo.ciarrocchi.googlepages.com/
>

Actually...no, it wouldn't help. Conflicts will coming up and only
the solution for now is to use remote tracking as Harvey wrote
in prev mail. (btw, git pull that would not conflict is when it
called with '-s ours' but that is not good)

- Cyrill -
