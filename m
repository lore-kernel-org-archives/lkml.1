Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYLHKxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYLHKxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 05:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYLHKxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 05:53:43 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:19487 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYLHKxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 05:53:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FHFHm4sFlecNyRqZmbdXXclcplw/0dJJxbKuyR9shG5SHRyemC5zM+NJQconp1pvHC
         rEnmLiMKB1Nxnm8yvpZQmbHD5IdFzNJRy2fV1jpsZI5dIhH4Qvk2p5szERIJMW4o3ns3
         p9qKcGzXqVFQuABwwaoBGC9n32ddk6i9JfVuY=
Message-ID: <12bfabe40812080253k4154bc12he014496c027f4a85@mail.gmail.com>
Date: Mon, 8 Dec 2008 11:53:41 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Andi Kleen" <ak@linux.intel.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <493CF65B.30408@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <493B4242.1040202@shaw.ca>
	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>
	 <20081207141337.588aede5@infradead.org>
	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
	 <493CCFE4.2080802@jp.fujitsu.com>
	 <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>
	 <493CEAA0.50201@jp.fujitsu.com> <493CEF38.3060004@linux.intel.com>
	 <493CF65B.30408@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I said in a previous post, the boot option mce=nobootlog solved the
problem at least from live-system point of view. About the problem at
rebooting/halting time(reboot enters a cycle, halt gives an mce), do
you have any suggestion? It seems like my bios is already the most
recent version available(F3). My motherboard is a Gigabyte
GA-EX58-UD5.

On 12/8/08, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> Andi Kleen wrote:
>> The weird thing is that 301 seconds is quite a long delay for that.
>> It should happen  relatively quickly at boot as the CPUs are initialized.
>
> Indeed.
>
>> When it happens consistently at each boot then yes it's likely something
>> leaking from the BIOS initialization sequence. Perhaps try a BIOS update?
>
> I'm not sure but is it make sense if SMI causes an error and dropped MCE
> exception without clearing error record?
>
> Thanks,
> H.Seto
>
>
