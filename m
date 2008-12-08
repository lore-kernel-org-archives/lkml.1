Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbYLHMh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbYLHMh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 07:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYLHMhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 07:37:50 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:54394 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbYLHMht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 07:37:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a4kYl0PUOOcnDi9h3EN7v+1Lyed+7YkM780FwJblxePXRP1xYQ1Ewj6tDG4EuUv//a
         we/81JBcS4UbvrjW13/RBFo9XmQaLy4RH7PkH+jXMSArjxOn1XmTwmXXso8Q/Itow2r6
         +kBvIeCIa3/DRYww6rEWZZuMBsmvXcUkRusXs=
Message-ID: <12bfabe40812080437o3655b15dm6234fc1d065c75c6@mail.gmail.com>
Date: Mon, 8 Dec 2008 13:37:47 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Andi Kleen" <ak@linux.intel.com>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <493D0D42.2090203@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>
	 <20081207141337.588aede5@infradead.org>
	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
	 <493CCFE4.2080802@jp.fujitsu.com>
	 <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>
	 <493CEAA0.50201@jp.fujitsu.com> <493CEF38.3060004@linux.intel.com>
	 <493CF65B.30408@jp.fujitsu.com> <493D0D42.2090203@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2008 at 1:04 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
>> I'm not sure but is it make sense if SMI causes an error and dropped MCE
>> exception without clearing error record?
>
> I wouldn't expect an SMI causing an internal cache machine check. That
> really
> looks more like something that comes out of the initialization code. But
> I haven't see it on any Nehalem system so far.
>
> Also it might be really some problem with this particular CPU.
>
> -Andi
>
If there's any test and/or anything else I can do to help tracking
down what exactly causes the problem, just let me know. I've already
done many cpu+memory intensive tests(in Linux for example a tbench
with 256 threads and various kernel compilations) to see if the mce
appears during normal working time of the cpus, but nothing happened.
As I've already said in this thread, the mce appears only at a
particular moment after reboot. So I have exactly 1 mce log after
every reboot, always at [  301.7320xx] and with mce=nobootlog no mce
gets logged. Windows Vista never gave me the BSOD, not even while
taking all the tests of 3D Mark Vantage(yes, even if I'm a grown up, I
still like VGs). The fact that windows never crashed should mean that
the mce was never triggered on that OS, could that be somewhat related
to the other problem I talked about here, i.e. that I cannot reboot on
Linux and I'm forced to halt the system everytime I want to reboot,
while on windows I don't have any similar problem?
