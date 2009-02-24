Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZBXLYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZBXLYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 06:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZBXLY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 06:24:26 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:27888 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754181AbZBXLYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 06:24:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zsUAdVHqgLzdr0typPzfht8rFRnkP4JCH3waoX/pyRZNSVD5o3kDXn9xJdlx6qykHk9VQAZee/PQrbhim/lHmrQkXqvhvooB9kif1tdVmUUn5D0X0lFSqjgLeBYZy4mwYlMHFHdDyl+0HQHFQ4PJ9vLaIcy9iPSXwilEJN11gBI=  ;
X-YMail-OSG: ARaLpIwVM1kXaltPmdFhHEAHtk3OcsXV7C7j7cd.LQtMyRFz_XK87oGl8Aj24Lu_OjqlCcvo7dXEjgkCv7MNpB81YBBCfaidv..U6ZCNxp9vdGD4UuQm6wj.OBUx7.SEldXxAIGUR87_EyOVXGa0eRudKOHlnMZApLzcYEwkLCUJfETSOLpzCTzhpxl.pZQlptzTTb.I993kYAXy_ArFSdauxr0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: luis6674@yahoo.com
Subject: Re: [Bug #12337] ~100 extra wakeups reported by powertop
Date: Tue, 24 Feb 2009 22:23:38 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <37338.58465.qm@web53304.mail.re2.yahoo.com>
In-Reply-To: <37338.58465.qm@web53304.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902242223.39069.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009 21:53:44 Alberto Gonzalez wrote:
> --- On Mon, 2/23/09, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > The following bug entry is on the current list of known
> > regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it
> > still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	:
> > http://bugzilla.kernel.org/show_bug.cgi?id=12337
> > Subject		: ~100 extra wakeups reported by powertop
> > Submitter	: Alberto Gonzalez <luis6674@yahoo.com>
> > Date		: 2008-12-31 12:25 (55 days old)
>
> Still present, yes.

Any chance you could bisect it?

