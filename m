Return-Path: <linux-kernel-owner+w=401wt.eu-S1763570AbZEOSDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763570AbZEOSDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763384AbZEOSC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:02:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:44543 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763442AbZEOSC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:02:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=mh2FerMIJW3NT838+MzMR2rMLbgj53NGnchkNuq/xH4mrGI5lOuvIccQ/Qm9dqibrK
         OvgTKux9LEoBDb2OsXU2wcEjuDVwFKq3Z6axzSO6Oh1dYY3qJFAMkrP1L/cr2c5Br8dA
         fMpN8uTMi466KhURwQdO821BSDkd96CBD/oAY=
MIME-Version: 1.0
In-Reply-To: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
References: <93655eb70905151007v5f9bb34aj34be4b65ffeb02a4@mail.gmail.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Fri, 15 May 2009 11:02:37 -0700
X-Google-Sender-Auth: 91809e180d726d9c
Message-ID: <2c0942db0905151102y4f144437xa02632effccda72c@mail.gmail.com>
Subject: Re: unresponsiveness on linux desktop during file copy
To: Satish Eerpini <eerpini@gmail.com>, Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 10:07 AM, Satish Eerpini <eerpini@gmail.com> wrote:
> Hello everyone,
>
> I am trying to figure out why the Linux desktop becomes overly
> unresponsive whenever there is a file copy going on, this happens to a
> large extent with GUI based file copying, and some lesser, but with
> command line copying too.
> does it have anything to do with the kernel ??,
> if it does help, then I am running Fedora 10 on a Hp nx 7400, Centrino
> Duo processor.

Which kernel version? If it's something recent, your programs may be
getting swapped out due to a flaw in the latest kernels, where it
accidentally prefers caching file data over mapped pages. If that's
the case, Rik (cc:d) is working on patches to address the issue, and
may appreciate another tester.
