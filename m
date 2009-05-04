Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZEDKA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZEDKA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZEDKAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:00:45 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43528 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbZEDKAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:00:43 -0400
Message-ID: <49FEBBC9.9000708@cosmosbay.com>
Date: Mon, 04 May 2009 11:56:25 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Avi Kivity <avi@redhat.com>, Elad Lahav <elahav@uwaterloo.ca>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Implementation of the sendgroup() system call
References: <49FE47A1.7070700@uwaterloo.ca> <87eiv5ibnd.fsf@basil.nowhere.org> <49FE9999.7090103@redhat.com> <20090504095300.GF23223@one.firstfloor.org>
In-Reply-To: <20090504095300.GF23223@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 04 May 2009 11:56:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :

>>> Or perhaps simple send to a local multicast group and let
>>> some netfilter module turn that into regular UDP.
>>>  
>> Sounds hacky and rooty.
> 
> rooty? Everyone can send to all directions anyways.
> 
> It wouldn't be perfect, but quite usable as a short term solution
> for a production server.

Anyway, a netfilter module doesnt fit the needs (separate header/footer
for each destination)


