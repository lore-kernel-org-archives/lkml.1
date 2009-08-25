Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbZHYUdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbZHYUdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZHYUdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:33:32 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43764 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbZHYUdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:33:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=isAy1exaHo3D8D5giZzTzueIHJDDAibVqUigPPsh6xoFWp+Iu2J5EkW2JOpUXo2Uyd
         J4clIVpVy2x68UjWOJF69v20uwA5U2MYmsRLoeObl7qNmoE7iApsw94rX7hmYg1W5EgK
         FrvHLCYD5Di5ntrjZ0gXrfFLUiorkC4sbiL0Y=
MIME-Version: 1.0
In-Reply-To: <200908251251.37135.bjorn.helgaas@hp.com>
References: <c4e36d110908250110xe16720o977c8cf5c3386c4b@mail.gmail.com>
	 <200908251251.37135.bjorn.helgaas@hp.com>
Date: Tue, 25 Aug 2009 22:33:30 +0200
Message-ID: <c4e36d110908251333p2da20276j650232cea8da4c1f@mail.gmail.com>
Subject: Re: INFO: possible circular locking dependency - kacpid 
	acpi_os_wait_events_complete
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/25 Bjorn Helgaas <bjorn.helgaas@hp.com>:
> On Tuesday 25 August 2009 02:10:58 am Zdenek Kabelac wrote:
>> Now with 2.6.31-rc7 (3edf2fb9d80a46d6c32ba12547a42419845b4b76)
>>  I'm getting this  INFO trace - also I've noticed complete reset during resume
>> which could be eventually related to this ?
>
> What's the most recent kernel where this did not occur?  Is this
> a regression since 2.6.30?
>
>> My machine - T61, 4GB, C2D
>> I suspect that some resent  thinkpad-acpi changes.
>
> Do you have any evidence that points to thinkpad_acpi?  I looked
> at the recent changes there, and I don't see anything obviously
> related to kacpid or deferred work.
>

Well I've never seen this INFO trace before - also I'm not sure I
could reliable retest it - might be coincidence of suspend out of port
replicator and resume while being attached on it - however I do this
relatively often and I start to see this after I' started to use -rc7
kernel.

My guess is purely based on the fact that commit touching functions
from INFO trace was recently merged to main tree.

If there will be some time I could try to make few tests for suspend
resume - but I hope the trace would be enough for analysis.

Zdenek
