Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZDVUWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZDVUWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZDVUW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:22:28 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:17034 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZDVUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Vfb++l7F+/AYYLkg/0tEg4vpk/6FlrnmYjglgLt2ZEwMpknWadPS+CsSbh9vub7A+A
         tSHzwdQqgaMeMQ08E0wfbQANgmloW3dnQ7USy28OzKmys6E46lDPw1acKaZPlu7urg9w
         vjdX/vifNRixQbfMnwhaoi0jXSqmrRRpIi6eY=
MIME-Version: 1.0
In-Reply-To: <20090422193728.GI4691@vespa.holoscopio.com>
References: <1240237621-11415-1-git-send-email-cascardo@holoscopio.com>
	 <200904202114.01932.rjw@sisk.pl>
	 <20090421215248.GF6147@vespa.holoscopio.com>
	 <200904220017.19670.rjw@sisk.pl>
	 <20090422043828.GB3979@vespa.holoscopio.com>
	 <9929d2390904212246n4817b25r4db653cd7e6a24c1@mail.gmail.com>
	 <20090422193728.GI4691@vespa.holoscopio.com>
Date: Wed, 22 Apr 2009 13:22:25 -0700
X-Google-Sender-Auth: aabc66bb01368972
Message-ID: <9929d2390904221322v1c00b0c8see98efb4354cb173@mail.gmail.com>
Subject: Re: [PATCH v2 fixed] e100: do not go D3 in shutdown unless system is 
	powering off
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 12:37 PM, Thadeu Lima de Souza Cascardo
<cascardo@holoscopio.com> wrote:
> On Tue, Apr 21, 2009 at 10:46:19PM -0700, Jeff Kirsher wrote:
>> On Tue, Apr 21, 2009 at 9:38 PM, Thadeu Lima de Souza Cascardo
>> <cascardo@holoscopio.com> wrote:
>> > After experimenting with kexec with the last merges after 2.6.29, I've
>> > had some problems when probing e100. It would not read the eeprom. After
>> > some bisects, I realized this has been like that since forever (at least
>> > 2.6.18). The problem is that shutdown is doing the same thing that
>> > suspend does and puts the device in D3 state. I couldn't find a way to
>> > get the device back to a sane state in the probe function. So, based on
>> > some similar patches from Rafael J. Wysocki for e1000, e1000e and ixgbe,
>> > I wrote this one for e100.
>> >
>> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>> > ---
>>
>> Thanks, I will add it to my queue of patches for e100.
>>
>> Also, just FYI, Auke is no longer a maintainer for
>> e100/e1000/e1000e/igb/ixgb/ixgbe devices, so I have removed him from
>> the thread.
>>
>> --
>> Cheers,
>> Jeff
>
> Perhaps, Rafael should be mentioned in a Reviewed-by? As well as you if
> you did review it? I guess a Tested-by and Reported-by me is overkill,
> right? :-)
>

Correct, that would be overkill.  If Rafael wants his Ack or
Reviewed-by added, he will let us know.

Once we have done some regression testing on the patch, I will add my
signed-off-by before sending it to Dave.

-- 
Cheers,
Jeff
