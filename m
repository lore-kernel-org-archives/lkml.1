Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbZIPGBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbZIPGBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbZIPGBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:01:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47176 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbZIPGBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:01:41 -0400
Message-ID: <4AB07F39.4080205@zytor.com>
Date: Tue, 15 Sep 2009 23:01:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: x86-PAT tree merge causes keyboard problems
References: <20090915205259.GA1910@phenom2.trippelsdorf.de> <4AB018C0.30203@zytor.com> <20090916052657.GA1897@phenom2.trippelsdorf.de>
In-Reply-To: <20090916052657.GA1897@phenom2.trippelsdorf.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2009 10:26 PM, Markus Trippelsdorf wrote:
> 
> OK. I've attached most of those.
> The Xorg.log is also interesting:
> 
> (EE) XKB: Could not invoke xkbcomp
> (EE) XKB: Couldn't compile keymap
> (WW) Couldn't load XKB keymap, falling back to pre-XKB keymap
> 

Okay, that explains the keyboard failure.  What you're really seeing is
a systemic failure of the X server.  Suresh thought it might be mapping
the frame buffer incorrectly.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

