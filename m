Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZLBNza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZLBNza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZLBNz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:55:28 -0500
Received: from smtp.nokia.com ([192.100.122.230]:40302 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZLBNz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:55:26 -0500
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
	<87iqcpk3wp.fsf@trdhcp146196.ntc.nokia.com>
	<20091202120240.GA19094@sirena.org.uk>
From: jouni.hogander@nokia.com (=?utf-8?Q?H=C3=B6gander?= Jouni)
Date: Wed, 02 Dec 2009 15:55:14 +0200
In-Reply-To: <20091202120240.GA19094@sirena.org.uk> (ext Mark Brown's message of "Wed\, 2 Dec 2009 13\:02\:41 +0100")
Message-ID: <877ht5jxa5.fsf@trdhcp146196.ntc.nokia.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Dec 2009 13:55:20.0593 (UTC) FILETIME=[163D1010:01CA7357]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> On Wed, Dec 02, 2009 at 01:32:06PM +0200, H??gander Jouni wrote:
>> ext Mark Brown <broonie@opensource.wolfsonmicro.com> writes:
>
>> > I'd add it as a fixed voltage regulator and either not specify the
>> > voltage or specify the nominal voltage.
>
>> I was preparing patch for this when I noticed that fixed voltage
>> regulator can control only one regulator. Are you aware of any ongoing
>> work to enable control for multiple regulators in
>> fixed-voltage-regulator?
>
> It's just a platform device configured with platform data, you can
> instantiate as many fixed voltage regulators in your system as you care
> to using the current driver.

Yes, you are right. This was just my mistake in usage of the
driver. Thanks for the clarification.

-- 
Jouni Högander
