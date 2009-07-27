Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZG0Won@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZG0Won (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZG0Wom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:44:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43016 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZG0Wom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:44:42 -0400
Date: Tue, 28 Jul 2009 00:44:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Add function to convert between calendar time
	and broken-down time for universal use
Message-ID: <20090727224432.GB7142@elf.ucw.cz>
References: <4A5C3BC0.6020701@cn.fujitsu.com> <20090714151040.b7b3b26d.akpm@linux-foundation.org> <20090718115019.GH1433@ucw.cz> <04e101ca08e5$be078fa0$808410ac@zhaoleiwin> <20090719202018.497f7ec1.akpm@linux-foundation.org> <4A643EFE.7090103@cn.fujitsu.com> <4A643F36.5090200@cn.fujitsu.com> <87ocr9mi8h.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ocr9mi8h.fsf@devron.myhome.or.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-07-25 14:42:06, OGAWA Hirofumi wrote:
> Zhaolei <zhaolei@cn.fujitsu.com> writes:
> 
> > +/*
> > + * Similar to the struct tm in userspace <time.h>, but it needs to be here so
> > + * that the kernel source is self contained.
> > + */
> > +struct tm {
> > +	/*
> > +	 * the number of seconds after the minute, normally in the range
> > +	 * 0 to 59, but can be up to 60 to allow for leap seconds
> > +	 */
> > +	int tm_sec;
> > +	/* the number of minutes after the hour, in the range 0 to 59*/
> > +	int tm_min;
> > +	/* the number of hours past midnight, in the range 0 to 23 */
> > +	int tm_hour;
> > +	/* the day of the month, in the range 1 to 31 */
> > +	int tm_mday;
> > +	/* the number of months since January, in the range 0 to 11 */
> > +	int tm_mon;
> > +	/* the number of years since 1900 */
> > +	int tm_year;
> 
> Why isn't this "long"? "int" can overflow.

Overflow? Year?

I'm not sure how far ahead you are looking, but support for year
2000000000 (2e9) seems perfectly okay to me. (Our friendly star here,
sun, is going to die at cca year 5e9, for comparison. )

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
