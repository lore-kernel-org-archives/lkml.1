Return-Path: <linux-kernel-owner+w=401wt.eu-S933011AbYBNNev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbYBNNev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 08:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYBNNel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 08:34:41 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:31918 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYBNNek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 08:34:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nEgTr3/wuoMVN0s6HrIatk0CqeHEhzjCPTcNAzbCZCDkIOhOkf+XqWiPYm7QbUrNN/odiXW75ynX/alz9f0yttFYHF5ZYpR2NWvQb9dlP+uCgH4xEVPBB14y3qu7W7cZRODm5M5d2lPiO4fPE6WOjB6PQ3hJmvk/qtZsJiE2538=
Message-ID: <9a8e2be0802140534y6e013d89k908154456e5d20b4@mail.gmail.com>
Date: Thu, 14 Feb 2008 14:34:37 +0100
From: "=?ISO-8859-1?Q?Ricardo_J._Rodr=EDguez?=" <ricardo.rdez@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Semaphores with timeouts
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080214001454.4e8cb0eb@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <9a8e2be0802131608m7eef61efmaee332a661503f39@mail.gmail.com>
	 <20080214001454.4e8cb0eb@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> It's certainly possible to add one but the first question would be "why
> do you need it - what sort of API are you trying to build"
>

The protocol works in adhoc wireless mode, so when I send a packet,
I've to wait a  while before I send it again, like TCP timeout
retransmistions work.

Anyway, I've though maybe I can use SIGALRM to know when it expired
and do whatever...

-- 
Ricardo J. Rodríguez
www.deathhc.tk

#329385 | [Registered Linux User]
