Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYH0KFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYH0KFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 06:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbYH0KF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 06:05:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:64064 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYH0KFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 06:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VMM6cItLjZTyToO200N6Rdi7VTbEE726+0YgVhiaboP8ZM+YqFv/OkahLMIop+8JDz
         zVGx6zv3nj5IUwle9oaTl6vZYPeF3+NYT+Enof1/2LYF59Pi/rYWppF1VeAI6MdqJYCf
         hTzNnSLNe9tSr0qkffhKm/GUQhJOpQWSesfNQ=
Message-ID: <1ba2fa240808270305m7f505efak9fd0d36d5db09a1e@mail.gmail.com>
Date: Wed, 27 Aug 2008 13:05:23 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: pull request: wireless-2.6 2008-08-26
Cc: "David Miller" <davem@davemloft.net>, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1219835410.5359.24.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080827013009.GA15781@tuxdriver.com>
	 <1ba2fa240808270038r24d5eeb9l36fd70ef5ae904f5@mail.gmail.com>
	 <20080827.014041.230100807.davem@davemloft.net>
	 <1219835410.5359.24.camel@californication>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 2:10 PM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Dave,
>
>> > Afther massive ath9k merge I didn't see it was a conceptual problem.
>>
>> Stop right there.
>>
>> You don't see it as a problem because you're not the one who has to
>> explain all of this shit to Linus and ends up getting flamed by him
>> when inappropriate changes are in my tree outside of the merge window.
>
> I did a quick review of the offending patch queue. And some of them
> should go in since they are fixing real bugs (as far as I can tell from
> a quick review). Others have to clearly wait for the next merge window.
>
> Thomas, please go through the list of patches and pick the real bug
> fixes. The cleanup patches can't go in since they are after the merge
> window.

I just repeat myself again, for the current series except the scanning
cleaning patches these patches
are must. This particular patch is there just because the hidden AP
connectivity fixes were stacked above it.

 And being one of the offenders why Dave got flamed by Linus,
> there is no way to get these through. And my big offender was a
> regression that broke userspace and came with a lengthy commit message.

There is a central problem here, since I cannot really adjust driver
development progress from obvious reason with Linux merging window.
Upstream kernel is unfortunately not the only customer I report to. So
actually stable versions got half backed drivers depending on some
arbitrary time cut from my (selfish) development point of view.
In this particular point we are really only cleaning bug database, our
mistake here is that we didn't export these bug to external bugzilla.

> Speaking of which, you better have a more convincing commit message if
> you wanna get something in after the merge window. It should make clear
> why this is a bug or a regression and why it can't wait until the next
> merge window.

Yes, I've already got this message on 3 channels already :)

> Please take this into account for any future patches since Linus now set
> a really high bar for patches after the merge window.

Understood.
Tomas
