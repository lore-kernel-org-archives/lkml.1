Return-Path: <linux-kernel-owner+w=401wt.eu-S965884AbXEVRiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965884AbXEVRiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758940AbXEVRiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:38:46 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:55451 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139AbXEVRiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:38:46 -0400
Message-ID: <46532AA4.6080501@s5r6.in-berlin.de>
Date: Tue, 22 May 2007 19:38:44 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Simon Horman <horms@verge.net.au>, Adrian Bunk <bunk@stusta.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: RFC: kconfig select warnings bogus?
References: <20070519151523.GA26724@uranus.ravnborg.org>	 <4650074A.6000307@s5r6.in-berlin.de>	 <a781481a0705200438s634712e6v957d7085bca7407@mail.gmail.com>	 <46503542.50300@s5r6.in-berlin.de>	 <a781481a0705200457v70aae469n97be31fe55af4d91@mail.gmail.com>	 <46504876.9040802@s5r6.in-berlin.de>	 <a781481a0705200650v2ef7be85h19f8c8eb026a303b@mail.gmail.com>	 <46505DBD.5010005@s5r6.in-berlin.de>	 <a781481a0705220753g25bb0dd8u33bbf8ddaf00f50c@mail.gmail.com>	 <46532247.6030803@s5r6.in-berlin.de> <a781481a0705221013m45f82054tca9a9a78ea8935d4@mail.gmail.com>
In-Reply-To: <a781481a0705221013m45f82054tca9a9a78ea8935d4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 5/22/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> >> > On 5/20/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> >> >>         depends on !PLATFORM_X || HELPER_N_ON_PLATFORM_X
...
>> This is a synthetic example which might not have a real-world application.]
> 
> Well, it is not relevant / equivalent to any of the four symbols that caused the
> warnings that this thread is about, at least.

(Have I ever said that this concrete expression can be used in whatever
fix?)

...
> and as I said, this was totally *not* the problem being discussed /
> solved in this thread (and by that patch).

My point was not about that particular expression. My point was:

	I'm not advocating any specific fixes or pseudo-fixes.
	I'm advocating the notation of dependencies in the direction
	"A requires B".

When I said "The standard and maintainable way (for drivers at least)
is..." I didn't mean the example expression, I meant the *direction* in
which the example was stating dependencies.
-- 
Stefan Richter
-=====-=-=== -=-= =-==-
http://arcgraph.de/sr/
