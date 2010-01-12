Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032Ab0ALRxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab0ALRxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584Ab0ALRxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:53:30 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:53559 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab0ALRx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:53:28 -0500
Message-ID: <4B4CB712.8030806@gmail.com>
Date: Tue, 12 Jan 2010 18:53:22 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>
Subject: Re: [PATCH 1/2] net: tcp_header_len_th and tcp_option_len_th
References: <4B44FE3C.6060809@gmail.com> <4B450065.4010108@gmail.com> <4B4C519E.2090207@gmail.com> <4B4CB46C.8020502@gmail.com>
In-Reply-To: <4B4CB46C.8020502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 12 Jan 2010 18:53:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12/01/2010 18:42, William Allen Simpson a écrit :
> Eric Dumazet wrote:
>> Its better to inline your patches so that we can comment them, without
>> copy/paste
>>
>> When I hit 'reply to', my mailer only quoted the ChangeLog, not the
>> patch.
>>
> Seeing that we're both using Mozilla, how to you do it?
> 
> It took me many attempts to get this to work with Thunderbird on the Mac.
> 

Hmm, I followed Documentation/email-clients.txt tricks, I dont remember exact details.

I type my Changelog text, add my signature, then copy/paste patch from external editor
(this editor must preserve tabulations of course)

Its probably a bit odd, because I am stuck with a windows XP notebook here at work,
dont flame me :(



About cast games, maybe following way is the cleanest one.

int tcp_options_len_th(struct tcphdr *th)
{
	return tcp_header_len_th(th) - sizeof(*th);
}

