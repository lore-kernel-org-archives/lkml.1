Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYILSAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYILSAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 14:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbYILR7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:59:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:60173 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbYILR7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=FyEGl8UDZiI33mJ7kqi80hazix/DKTmy+5IGZCsp6x8ztlbmfnP1qj/K6VguT1kwRA
         8f6M7qUNMpL0TlxnNQSyDKC+g525B4dxDJ9GjWWP2Yoy0uSOAKAyGFZ1BFmCQ+xBjEOo
         eDNA443BADNV79KZjFipwrmVNpLsjlYaWZ4LM=
Message-ID: <b6c5339f0809121059s2949a887q81de84ac6ca3a2d7@mail.gmail.com>
Date: Fri, 12 Sep 2008 13:59:52 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: Partition check considered as error is breaking mounting in 2.6.27
Cc: "Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       bogdano@mandriva.com.br,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
In-Reply-To: <Pine.LNX.4.44L0.0809121316460.13261-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809121401.40158.herton@mandriva.com.br>
	 <Pine.LNX.4.44L0.0809121316460.13261-100000@iolanthe.rowland.org>
X-Google-Sender-Auth: 81df75a025cbfd5b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 1:36 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> I don't know if this change of behaviour in 2.6.27 is desired (not creating
>> partition nodes if its size exceeds media size).
>
> I have to believe that it _is_ desired.  Why else would that commit
> have been merged?

Several people objected to similar patches when they were posted on
LKML in the past, usually for the reason "this breaks my forensics use
case."  I guess no one objected this time around.

http://marc.info/?l=linux-kernel&m=116069718613683&w=2

(I don't have an opinion, I'm just providing collective memory.)

-- 
Bob Copeland %% www.bobcopeland.com
