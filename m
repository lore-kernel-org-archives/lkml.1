Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbYAVVMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbYAVVMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbYAVVMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:12:38 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:40699 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYAVVMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:12:37 -0500
Date: Wed, 23 Jan 2008 00:12:24 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Fries <david@fries.net>, linux-kernel@vger.kernel.org
Subject: Re: W1: w1_slave units, standardize 1C or .001C?  Break API
Message-ID: <20080122211224.GA434@2ka.mipt.ru>
References: <20080121231557.GA4025@spacedout.fries.net> <479541F5.9080705@zytor.com> <47955ECB.3050100@zytor.com> <20080122210741.GB30938@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080122210741.GB30938@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 12:07:41AM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> On Mon, Jan 21, 2008 at 07:11:07PM -0800, H. Peter Anvin (hpa@zytor.com) wrote:
> > >Millikelvins would have the nice property of never being negative.  :)
> > >
> > 
> > Alternatively, centikelvins would fit nicely in 16 bits if anyone cares...
> > 
> > 655.35 K = 382.20 œC = 719.96 œF
> 
> I have no objection on adding new sysfs files which will return
> temperature relative to one on Mars or Venus :)

Even more, what about possibility of changing of the base, relative to
which temperature is displayed? By default I vote for centigrades,
those, who live behind the oceans, can setup Fahrenheit, Kelvin or anything
else, but please in a new file :)
David will this work for you?

-- 
	Evgeniy Polyakov
