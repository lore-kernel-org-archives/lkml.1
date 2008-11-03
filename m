Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYKCOaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYKCOaR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbYKCOaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:30:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:62456 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbYKCOaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:30:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=av3qdAzPN9b7llD3xQIpFZYzLROtkxG7WTwnJC9/t3S+PDm3h9OrIn9eLm6EYQ6Zp+
         rxuqRi+eFg2MqNwbgPlZAAfQczEfGb6Ne70P2UpGve9i8MgJFkUoF89uI9QUoE10TdH6
         DlaAOiVnzVF3vY7CEe4Y0HXUzmP4BLPfjT4Zs=
Message-ID: <490F0ACC.4000808@tuffmail.co.uk>
Date: Mon, 03 Nov 2008 14:29:32 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4
References: <490B3BB5.8060801@tuffmail.co.uk> <20081031171126.GA17313@srcf.ucam.org> <490B4014.4040009@tuffmail.co.uk> <490B70A3.8010108@tuffmail.co.uk> <20081102040008.GB29606@khazad-dum.debian.net> <490D8C4E.3010201@tuffmail.co.uk> <20081102130655.GA12766@srcf.ucam.org> <20081103141628.GB31078@khazad-dum.debian.net> <20081103141836.GA31894@srcf.ucam.org>
In-Reply-To: <20081103141836.GA31894@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Mon, Nov 03, 2008 at 12:16:28PM -0200, Henrique de Moraes Holschuh wrote:
>
>   
>> Can you read the state?  If so, you need to unconditionally do so on resume
>> (from sleep or hibernation) and rfkill_force_state() it.
>>     
>
> The rfkill core actually forces the state on resume, so I think we're 
> fine.
>   

I think the reason it works is because eeepc-laptop provides a
"get_state" callback.  rfkill can call get_state on resume, and if the
state has changed, force it back to the old value.  So I think it's ok
as is.

Alan
