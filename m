Return-Path: <linux-kernel-owner+w=401wt.eu-S1751953AbZJWWYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbZJWWYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 18:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZJWWYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 18:24:08 -0400
Received: from claw.goop.org ([74.207.240.146]:39192 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZJWWYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 18:24:07 -0400
Message-ID: <4AE22D04.50708@goop.org>
Date: Fri, 23 Oct 2009 15:24:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Ryan C. Gordon" <icculus@icculus.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] binfmt_elf: FatELF support for kernel modules.
References: <alpine.DEB.2.00.0910190422090.13303@andre.icculuslan> <4ADD0086.9060304@goop.org> <alpine.DEB.2.00.0910200043200.18342@andre.icculuslan>
In-Reply-To: <alpine.DEB.2.00.0910200043200.18342@andre.icculuslan>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/09 21:54, Ryan C. Gordon wrote:
> I can understand that concern, but I worry about refusing to take steps 
> that would aid free software developers in case it might help the 
> closed-source people, too.
>   

Any open source driver should be encouraged to be merged with mainline
Linux so there's no need to distribute them separately.  With the
staging/ tree, that's easier than ever.

I don't see much upside in making it "easier" to distribute binary-only
open source drivers separately.  (It wouldn't help that much, in the
end; the modules would still be compiled for some finite set of kernels,
and if the user wants to use something else they're still stuck.)

> Those that will behave badly will do so regardless of file formats, but 
> distros shipping nothing but GPL'd software and in-tree drivers would 
> benefit from this more than another misguided company that probably 
> doesn't care about multiple CPU architectures anyhow.
>   

Well, ideally a fat module would allow modules for multiple kernels to
be bundled together (same and/or different architectures), which is
primarily useful for 3rd-party binary distributions.


    J
