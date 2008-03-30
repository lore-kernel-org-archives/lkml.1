Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYC3VSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYC3VSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 17:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYC3VSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 17:18:25 -0400
Received: from mx2.orcon.net.nz ([219.88.242.52]:33483 "EHLO mx2.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbYC3VSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 17:18:24 -0400
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Bob Tracy <rct@frus.com>,
       Tyson Whitehead <twhitehe@uwo.ca>, Takashi Iwai <tiwai@suse.de>,
       ALSA devel <alsa-devel@alsa-project.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org
Message-Id: <AC20DA6E-C360-4F63-8C46-65E488475CDB@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
In-Reply-To: <20080330161400.GA24443@jurassic.park.msu.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
Date: Mon, 31 Mar 2008 10:17:41 +1300
References: <20080329064227.58074DBA2@gherkin.frus.com> <47EE317E.9030807@keyaccess.nl> <20080330161400.GA24443@jurassic.park.msu.ru>
X-Mailer: Apple Mail (2.919.2)
X-DSPAM-Check: by mx2.orcon.net.nz on Mon, 31 Mar 2008 10:17:47 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Mar 31 10:18:20 2008
X-DSPAM-Confidence: 0.9868
X-DSPAM-Improbability: 1 in 7486 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/03/2008, at 5:14 AM, Ivan Kokshaysky wrote:

> On Sat, Mar 29, 2008 at 01:09:34PM +0100, Rene Herman wrote:
>> Okay. The thing that "fixed" Tyson was disabling mmap from the  
>> driver:
>>
>> http://mailman.alsa-project.org/pipermail/alsa-devel/2008-March/006911.html
>
> Weird - I was sure the mmap problem has been fixed, but obviously
> the patch didn't go in...
>
> Andrew, could you please queue this up for 2.6.26?

I have applied the patch against the 2.6.24.3 kernel, and now have  
working sound on the newer PWS600au with mmap enabled alsa.  Verified  
through the on board ESS1887 and via the M-Audio Revolution 7.1 sound  
card.  (Ran out of time to also try the C-Media sound card.  Also ran  
out of time to try it out on the other alphas I have.)

The problem with the repeated sound bits playing at the end of certain  
sound files via the ESS1887 remains.

Michael.

