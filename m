Return-Path: <linux-kernel-owner+w=401wt.eu-S1763111AbYESUFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763111AbYESUFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760725AbYESUFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:05:42 -0400
Received: from smtp105.rog.mail.re2.yahoo.com ([206.190.36.83]:35314 "HELO
	smtp105.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760564AbYESUFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:05:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=p6n/CH0FAa8aDCcpC3r5ovuOW3LSETQrlMZrfrf1ClCE3HyfOuOXbGaqWMvJt0VoSLv9ZoRDWMtH9q4VTPMFMoNWdTCrCTO2QenL/7XedgF4wrFgoxdzNsogMJpJJ0+NrLWTVXjVCrS8ZWIiXQRSiidoXMrKlMSGnsqoRtVi8So=  ;
X-YMail-OSG: ptzLi_oVM1mlHsu2yLQ_8pPn14mH1SlbeIViMrh_x9G4rJ61ofEKe_dOisC8yvHiiw--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: Modern 2.6 kernels - Notification for changing hostname from proc/sys/kernel/hostname ?
Date: Mon, 19 May 2008 16:05:31 -0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200805191316.12424.shawn.starr@rogers.com> <20080519204535.GA23629@martell.zuzino.mipt.ru>
In-Reply-To: <20080519204535.GA23629@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805191605.32484.shawn.starr@rogers.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008 04:45:35 pm Alexey Dobriyan wrote:
> On Mon, May 19, 2008 at 01:16:12PM -0400, Shawn Starr wrote:
> > I was looking at utsname_sysctl.c (if this is the right place) and
> > noticed there doesn't seem to be any notification via the connector bus
> > to tell userspace the hostname has changed? Is this correct?
>
> Yes. No notifications.
>
> > if so, would not not make sense to add such event triggers so that things
> > like KDE would not have to poll to determine if the hostname changes and
> > instead had D-BUS tell userspace the hostname changed?
>
> Why does it want to know if and when hostname changes?
>
Well, It's for keeping track of the X session, if the hostname changes things 
go bad.

> > Perhaps this could be applied to other values (where applicable)
> > in /proc/sys/kernel?
>
> Probably, what other stuff desktop crowd wants?

No idea on the other values, but maybe others can jump in on this discussion?

>
> > Or is this all going to go into sysfs eventually (where some of this
> > really might belong)
>
> Hopefully, not. There is already uname(2), sysctls -- proc and binary,

Hopefully this can all be cleaned up, we really should have one unified place 
for kernel tweaking/settings either /proc or /sys.
