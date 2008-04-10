Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbYDJS1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbYDJS1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 14:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYDJS1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 14:27:44 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50528 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbYDJS1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 14:27:43 -0400
Date: Thu, 10 Apr 2008 11:26:16 -0700
From: sukadev@us.ibm.com
To: Paul Menage <menage@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@osdl.org>,
       clg@fr.ibm.com, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] clone64() and unshare64() system calls
Message-ID: <20080410182616.GF28477@us.ibm.com>
References: <20080409222611.GA28087@us.ibm.com> <47FD5899.2040206@zytor.com> <20080410010717.GA28477@us.ibm.com> <47FD6921.6090408@zytor.com> <20080410023818.GD28477@us.ibm.com> <6599ad830804091943j1f8a4500w5eda7774adfba69f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830804091943j1f8a4500w5eda7774adfba69f@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage [menage@google.com] wrote:
| On Wed, Apr 9, 2008 at 7:38 PM,  <sukadev@us.ibm.com> wrote:
| >
| >  But as Jon Corbet pointed out in the the thread above, it looked like
| >  adding a new system call has been the "traditional" way of solving this
| >  in Linux so far and there has been no consensus on a newer approach.
| >
| 
| I thought that the consensus was that adding a new system call was
| better than trying to force extensibility on to the existing
| non-extensible system call.

There were couple of objections to extensible system calls like
sys_indirect() and to Pavel's approach.

| 
| But if we are adding a new system call, why not make the new one
| extensible to reduce the need for yet another new call in the future?

hypothetically, can we make a variant of clone() extensible to the point
of requiring a copy_from_user() ?

| 
| Paul
