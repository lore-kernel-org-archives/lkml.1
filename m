Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbZH3TwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbZH3TwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 15:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZH3TwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 15:52:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:19619 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZH3TwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 15:52:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jXZN/AUHff5GeHkoTQFTOotsrTat2akKv6kdUneczeuW8akAbJHMH7VbMe1vP2YBnD
         sYAglWrjva4hcbTB//8y4+dmTqKoAxWBJgapaxuOcELnQ4PWI2p09dIgm6gpCaGbx6kS
         N/rK5sYq69uCajmroi3KkuLhvk14jsPko1ZQQ=
MIME-Version: 1.0
In-Reply-To: <200907211154.42563.knikanth@suse.de>
References: <200907211031.48294.knikanth@suse.de>
	 <20090721060114.GS24157@balbir.in.ibm.com>
	 <200907211154.42563.knikanth@suse.de>
Date: Sun, 30 Aug 2009 21:52:22 +0200
Message-ID: <3d8471ca0908301252j15cb33b1j913921bd8fc6704c@mail.gmail.com>
Subject: Re: [PATCH 1/3] taskstats-fork: Add a new taskstats command to get 
	notification on fork/clone
From: Guillaume Chazarain <guichaz@gmail.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       procps-feedback@lists.sf.net, Albert Cahalan <albert@users.sf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 8:24 AM, Nikanth Karthikesan<knikanth@suse.de> wrote:
> Ah.. proc-events was the exact thing, I was looking for! Thanks.

AFAICT proc-events can only be used by root, so that makes it
unsuitable for *top.

Anyway, iotop will always have to iterate over all threads to query
their taskstats and other attributes, so the O(nr_threads) complexity
is unavoidable.

Thanks.

-- 
Guillaume
