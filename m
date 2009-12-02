Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbZLBLcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbZLBLcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 06:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZLBLcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 06:32:15 -0500
Received: from smtp.nokia.com ([192.100.105.134]:52388 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbZLBLcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 06:32:12 -0500
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Valentin Eduardo \(Nokia-D\/Helsinki\)" <eduardo.valentin@nokia.com>,
       "De-Schrijver Peter \(Nokia-D\/Helsinki\)" 
	<Peter.De-Schrijver@nokia.com>,
       "Keski-Saari Juha.1 \(EXT-Teleca\/Helsinki\)" 
	<ext-juha.1.keski-saari@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "lrg\@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Subject: Re: Doubt about Regulator Framework and VBAT use case
References: <20091130104102.GA16608@esdhcp037198.research.nokia.com>
	<20091130114515.GB10968@rakim.wolfsonmicro.main>
From: jouni.hogander@nokia.com (=?utf-8?Q?H=C3=B6gander?= Jouni)
Date: Wed, 02 Dec 2009 13:32:06 +0200
In-Reply-To: <20091130114515.GB10968@rakim.wolfsonmicro.main> (ext Mark Brown's message of "Mon\, 30 Nov 2009 12\:45\:15 +0100")
Message-ID: <87iqcpk3wp.fsf@trdhcp146196.ntc.nokia.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Dec 2009 11:32:08.0367 (UTC) FILETIME=[14DF6BF0:01CA7343]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> On Mon, Nov 30, 2009 at 12:41:02PM +0200, Eduardo Valentin wrote:
>
>> I'm writing to ask about VBAT use case. What is the expected
>> way to use regulator framework in case of rail coming from battery?
>> Should it be added to the regulator framework at all?
>
> ...
>
>> However, drivers for devices on that rail would require their regulator anyway.
>> And I guess the point would be that drivers should not be aware that they are on VBAT
>> or any other rail.
>
> I'd add it as a fixed voltage regulator and either not specify the
> voltage or specify the nominal voltage.

I was preparing patch for this when I noticed that fixed voltage
regulator can control only one regulator. Are you aware of any ongoing
work to enable control for multiple regulators in
fixed-voltage-regulator?

-- 
Jouni Högander
