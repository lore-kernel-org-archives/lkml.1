Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZEKN7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZEKN7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbZEKN6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:58:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:64536 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZEKN6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:58:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=cUNBePa3aUTxpAuGdQ8OsZM9KphXG8/63tt+AqLCxu+6BIRjK7XTqY2F5PERzsjrb1
         Jw29h8pEuP3HPzz+eSPveyrmO1XaQ32u8XRnHX3qR9erWNtragNJQ92XRftqVOYIDvJ+
         SSMr4pw1PkEAMCd6QHf+bvFeUWSVZucyEn014=
MIME-Version: 1.0
Date: Mon, 11 May 2009 09:58:52 -0400
Message-ID: <8bfdd4d60905110658g186bc26el703eb1baf076616e@mail.gmail.com>
Subject: fixed timeslice
From: Jason mclaughlin <mcjason@gmail.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can't scheduling be unfair when a fixed timeslice is used as the time
up til a process can run?

won't it work out that if a program is using the harddrive, and
another is using cpu time and using up it's timeslices, that the
cpu user will give less runtime opportunity to the harddrive user
because of a wait up until timeslice to use the harddrive again?

like, doesn't the length of a timeslice change the fairness of
scheduling opportunity for harddrive use?

can't it span the time that something is ready to take from the
harddrive, til the time the harddrive can be used again?

can't it anyways in some cases though no matter what, because of how
using up til a timeslice is available sometimes when something wants
to use the harddrive again,
and because what wants to use the harddrive can be behind what uses a
whole timeslice?
