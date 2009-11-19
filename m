Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZKSAkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZKSAkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 19:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756317AbZKSAkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 19:40:40 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:48823 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbZKSAkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 19:40:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=m6w3zmw9rZlR0sP85o3iDY1GgCnFCqDi5jmhh8kExNYyYKm55AgkstqJk51NA+L41a
         Tt0gkJSClE5NN25zmCy6WAHWpqZ5x6282bd9YRt7qm+ctIKg2DYYh6WSUze0aaD2OGx2
         knBDPt2kj+DQkT+/ZzetiI0e8MenDlDw1M4fA=
MIME-Version: 1.0
In-Reply-To: <4B046AEA.80109@wpkg.org>
References: <4B046AEA.80109@wpkg.org>
Date: Wed, 18 Nov 2009 19:40:46 -0500
X-Google-Sender-Auth: 9261bd3a8cb76f22
Message-ID: <c0c067900911181640h64971680l4da14cdbe9fa6d59@mail.gmail.com>
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
From: Dan Merillat <dan.merillat@gmail.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: preining@logic.at, riel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 4:45 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:

> I have a pretty powerful desktop machine with 8 GB RAM, fast disks with
> RAID-1 etc.

> Every 10 minutes or so, machine is really unresponsive, load jumps to 10 or
> 20. Mouse pointer jumps, it's impossible to change between windows etc.

This is the type of hefty workstation many of the core developers
have, running similar workloads, so I'm somewhat surprised that the
default VM settings have this kind of issue.

> Do a "swapoff -a", and everything is snappy and responsive as it should,
> there are no more lags.

Yes, that's my exact finding.

Is this weird IO storm happening for anyone else with plenty of memory
(for their taskload?)
