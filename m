Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZA0Rhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZA0Rhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 12:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZA0Rhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 12:37:36 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:2292 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZA0Rhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 12:37:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ABP+gFBSbLb0yDiI4rV66T66V4AEtHniyNB2u8Lc9TCpXxUvz2eV0JiP0BrRIxB7Y6
         ld19orgM4wcKRyys39GBMf/4zc7iiB0hoN/TE5aseyGvdMimdOfBJkzcJnGZ8Er4Lh8I
         V1CkO1w0FcNiZBvVGEpFLcDChtWoEgG+eaFJs=
MIME-Version: 1.0
In-Reply-To: <1233031451.4851.31.camel@gaiman>
References: <497E4531.20800@nerdgrounds.com>
	 <5bdc1c8b0901261859g58a413e1x52208a6f2c1f9ccd@mail.gmail.com>
	 <1233031451.4851.31.camel@gaiman>
Date: Tue, 27 Jan 2009 09:37:32 -0800
Message-ID: <5bdc1c8b0901270937h27c48290p4fb5233f06593e44@mail.gmail.com>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
From: Mark Knecht <markknecht@gmail.com>
To: Eric Anholt <eric@anholt.net>
Cc: Jonathan Campbell <jon@nerdgrounds.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 8:44 PM, Eric Anholt <eric@anholt.net> wrote:
> On Mon, 2009-01-26 at 18:59 -0800, Mark Knecht wrote:
<SNIP>
>> >
>>
>> Can the GPU use the data placed in your file system? Do you have
>> strong control as to exactly how the data is mapped into VRAM? I'm
>> thinking about parallel processing  - Linux puts data there and then
>> the GPU works on it to produce a result which Linux can eventually
>> fetch.
>
> For that you want something like GEM, which is aware of the graphics
> pipeline and the cache management necessary.  Wrapping a filesystem
> around it shouldn't be hard, and would be of some use for debugging.
>
> --
> Eric Anholt

Right. I agree. However over time a number of us in the pro-audio area
have thought about using the GPU for things like building complex
reverb convolutions in real-time. Lots of parallelism in the math.
These machines are not typically very graphically intensive and the
VRAM on the cards isn't required but it's there. Somehow being able to
get data in and out of the VRAM using standard file commands, letting
something like GEM do the work, and then getting the data back seems
appealing.

I hope Jonathan keeps up the efforts. Interesting stuff.

- Mark
